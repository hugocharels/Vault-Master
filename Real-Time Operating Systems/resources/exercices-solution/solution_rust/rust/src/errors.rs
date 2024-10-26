use crate::models::{Job, TimeStep};

#[derive(Debug)]
pub enum SchedulingError {
    DeadlineMiss { job: Job, t: TimeStep },
}
