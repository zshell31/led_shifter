#![allow(incomplete_features)]
#![allow(clippy::let_and_return)]
#![feature(generic_const_exprs)]
pub mod state;

use state::State;

use ferrum_hdl::prelude::*;
use ferrum_hdl::rise_rate_constr;

pub struct ZynqMiniDom;

impl ClockDomain for ZynqMiniDom {
    const FREQ: usize = 50_000_000;
    const RESET_KIND: SyncKind = SyncKind::Sync;
    const RESET_POLARITY: Polarity = Polarity::ActiveLow;
}

pub const RATE: usize = 4;

pub type StateC = Idx<{ state::CYCLES }>;

pub fn leds<D: ClockDomain>(clk: &Clock<D>, rst: &Reset<D>) -> Signal<D, Array<{ state::N }, Bit>>
where
    ConstConstr<{ rise_rate_constr!(D, RATE) }>:,
{
    let en = rise_rate::<D, RATE>(clk, rst);

    reg_en(
        clk,
        rst,
        &en,
        &(StateC::new(), State::default()),
        |(counter, state)| {
            let counter = counter.succ();
            let change = counter.is_zero();

            let state = if change {
                state.change()
            } else {
                state.shift()
            };

            (counter, state)
        },
    )
    .map(|(_, state)| state.to_array())
}

pub struct TestSystem;

impl ClockDomain for TestSystem {
    const FREQ: usize = 8;
    const RESET_KIND: SyncKind = SyncKind::Sync;
    const RESET_POLARITY: Polarity = Polarity::ActiveLow;
}

type System = TestSystem;

pub fn top(clk: &Clock<System>, rst: &Reset<System>) -> Signal<System, Array<4, Bit>> {
    let led = leds::<System>(clk, &rst);
    led
}
