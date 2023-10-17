use std::fmt::Binary;

use ferrum_hdl::{
    array::Array,
    bit::Bit,
    bitpack::BitPack,
    signal::SignalValue,
    unsigned::{u, Unsigned},
};

pub const N: usize = 4;
pub const CYCLES: usize = 4 * TOTAL + 1;

const TOTAL: usize = N + N - 1;
const LEFT: u<7> = u((1 << N) - 1);
const RIGHT: u<7> = u(((1 << N) - 1) << (N - 1));

#[derive(Debug, Clone)]
pub enum State {
    Left(Unsigned<TOTAL>),
    Right(Unsigned<TOTAL>),
}

impl Binary for State {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Self::Left(left) => write!(f, "Left({:b})", left),
            Self::Right(right) => write!(f, "Right({:b})", right),
        }
    }
}

impl SignalValue for State {}

impl Default for State {
    fn default() -> Self {
        State::Left(LEFT.into())
    }
}

impl State {
    pub fn change(self) -> State {
        match self {
            Self::Left(_) => Self::Right(RIGHT.into()),
            Self::Right(_) => Self::Left(LEFT.into()),
        }
    }

    pub fn shift(self) -> State {
        match self {
            Self::Left(left) => Self::Left(if left == 0 { LEFT.into() } else { left << 1_u8 }),
            Self::Right(right) => Self::Right(if right == 0 {
                RIGHT.into()
            } else {
                right >> 1_u8
            }),
        }
    }

    pub fn to_array(self) -> Array<4, Bit> {
        match self {
            Self::Left(left) => left.pack().slice::<{ N - 1 }, N>().unpack(),
            Self::Right(right) => right.pack().slice::<0, N>().unpack(),
        }
    }
}
