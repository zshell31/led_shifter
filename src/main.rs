use ferrum_hdl::domain::Clock;
use ferrum_hdl::signal::{Reset, Signal, SignalValue};
use ferrum_hdl::simulation::{Simulate, Simulation};
use led_shifter::{leds, TestSystem};
use std::fmt::Debug;

fn print<T: SignalValue + Debug>(sim: &mut Simulation<Signal<TestSystem, T>>) {
    for value in sim.take(40) {
        println!("value = {:?}", value);
    }
}

fn main() {
    let clk = Clock::default();
    let rst = Reset::reset();

    let mut sim = leds::<TestSystem>(clk, &rst).simulate();
    print(&mut sim);
}
