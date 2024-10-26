from scheduling import Task, TaskSet


def test_task():
    task = Task(1, 0, 10, 10, 10)
    assert task.task_id == 1
    assert task.offset == 0
    assert task.wcet == 10
    assert task.deadline == 10
    assert task.period == 10
    assert task.jobs_released == 0


def test_spawn_job():
    task = Task(1, 0, 10, 10, 10)
    j = task.spawn_job(0)
    assert j is not None
    assert j.task == task
    assert j.deadline == 10
    assert task.spawn_job(1) is None

    j = task.spawn_job(10)
    assert j is not None
    assert j.task == task
    assert j.deadline == 20


def test_taskset():
    ts = TaskSet([])
    assert ts.release_jobs(0) == []

    t1 = Task(1, 0, 10, 10, 10)
    t2 = Task(2, 0, 20, 20, 20)
    ts = TaskSet([t1, t2])
    assert len(ts.release_jobs(0)) == 2
