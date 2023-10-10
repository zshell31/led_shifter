#![allow(incomplete_features)]
#![feature(generic_const_exprs)]
pub mod counter;
pub mod state;

use counter::{counter, Counter};
use state::State;

use ferrum_hdl::{
    array::Array,
    bit::{Bit, L},
    const_helpers::UsizeConstr,
    domain::{Clock, ClockDomain},
    signal::{reg, reg_en, Reset, Signal},
};

pub struct ZynqMiniDom;

impl ClockDomain for ZynqMiniDom {
    const FREQ: usize = 50_000_000;
}

pub const FREQ: usize = 8;

pub const fn counter_period<D: ClockDomain>(freq: usize) -> usize {
    D::FREQ / freq
}

#[allow(type_alias_bounds)]
pub type ShiftC<D: ClockDomain> = Counter<{ counter_period::<D>(FREQ) }>;
pub type StateC = Counter<{ state::CYCLES }>;

pub fn leds<D: ClockDomain>(clk: Clock<D>, rst: Reset<D>) -> Signal<D, Array<{ state::N }, Bit>>
where
    UsizeConstr<{ counter(counter_period::<D>(FREQ)) }>:,
{
    let en = reg(clk, rst.clone(), (ShiftC::<D>::new(), L), |(shift_c, _)| {
        let (shift_c, en) = shift_c.succ();
        (shift_c, en)
    })
    .map(|(_, en)| en);

    reg_en(
        clk,
        rst.clone(),
        en,
        (StateC::new(), State::default()),
        |(counter, state)| {
            let (counter, change) = counter.succ();

            let state = if change.into() {
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
}

type System = TestSystem;

#[allow(clippy::let_and_return)]
pub fn top_module(clk: Clock<System>) -> Signal<System, Array<4, Bit>> {
    let rst = Reset::reset();
    let led = leds::<System>(clk, rst);
    led
}
