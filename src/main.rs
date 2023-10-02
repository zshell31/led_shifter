use ferrum::domain::{Clock, ClockDomain};
use ferrum::signal::{Reset, Signal, SignalValue};
use ferrum::simulation::{Simulate, Simulation};
use led_shifter::leds;

pub struct TestSystem;

impl ClockDomain for TestSystem {
    const FREQ: usize = 8;
}

fn print<T: SignalValue>(sim: &mut Simulation<Signal<TestSystem, T>>) {
    for value in sim.take(40) {
        println!("value = {:?}", value);
    }
}

fn main() {
    let clk = Clock::default();
    let rst = Reset::reset();

    let mut sim = leds::<TestSystem>(clk, rst).simulate();
    print(&mut sim);
}
