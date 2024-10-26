from dataclasses import dataclass


@dataclass
class Task:
    task_id: int
    offset: int
    wcet: int
    deadline: int
    period: int
    jobs_released: int

    def __init__(self, task_id: int, offset: int, wcet: int, deadline: int, period: int):
        self.task_id = task_id
        self.offset = offset
        self.wcet = wcet
        self.deadline = deadline
        self.period = period
        self.jobs_released = 0

    def spawn_job(self, time: int):
        # Avoid circular imports
        from .job import Job

        # Release a job is the time is a multiple of the period
        if (time - self.offset) % self.period == 0:
            self.jobs_released += 1
            return Job(self, time + self.deadline, self.wcet, self.jobs_released)
