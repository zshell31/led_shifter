use ferrum_hdl::{
    bit::{Bit, H, L},
    cast::{Cast, CastFrom},
    const_functions::clog2,
    signal::SignalValue,
    unsigned::Unsigned,
};
use std::fmt::{Binary, Debug};

pub const fn counter(n: usize) -> usize {
    clog2(n)
}

#[derive(Clone)]
pub struct Counter<const N: usize>(Unsigned<{ counter(N) }>)
where
    [(); counter(N)]:;

impl<const N: usize> Debug for Counter<N>
where
    [(); counter(N)]:,
{
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        Debug::fmt(&self.0, f)
    }
}

impl<const N: usize> Binary for Counter<N>
where
    [(); counter(N)]:,
{
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        Binary::fmt(&self.0, f)
    }
}

impl<const N: usize> Default for Counter<N>
where
    [(); counter(N)]:,
{
    fn default() -> Self {
        Self::new()
    }
}

impl<const N: usize> SignalValue for Counter<N> where [(); counter(N)]: {}

impl<const N: usize> Counter<N>
where
    [(); counter(N)]:,
{
    #[inline]
    pub fn new() -> Self {
        Self(0_u8.cast())
    }

    #[inline]
    pub fn is_max(&self) -> bool {
        let max = self.0 == Unsigned::cast_from(N - 1);
        max
    }

    #[inline]
    pub fn is_min(&self) -> bool {
        let min = self.0 == 0;
        min
    }

    pub fn succ(self) -> (Self, Bit) {
        let (value, succ) = if self.is_max() {
            (0_u8.cast(), H)
        } else {
            (self.0 + 1, L)
        };
        (Self(value), succ)
    }

    pub fn pred(self) -> (Self, Bit) {
        let (value, pred) = if self.is_min() {
            ((N as u128).cast(), H)
        } else {
            (self.0 - 1, L)
        };
        (Self(value), pred)
    }
}
