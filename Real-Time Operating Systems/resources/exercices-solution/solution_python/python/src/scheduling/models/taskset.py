from dataclasses import dataclass
from .task import Task
from .job import Job


@dataclass
class TaskSet:
    tasks: list[Task]

    def release_jobs(self, t: int) -> list[Job]:
        jobs = []
        for task in self.tasks:
            if t % task.period == 0:
                jobs.append(task.spawn_job(t))
        return jobs
