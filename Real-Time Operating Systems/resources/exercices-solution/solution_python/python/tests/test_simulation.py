from scheduling import Task, TaskSet, rate_monotonic, simulate, exceptions


def test_run_ok():
    t1 = Task(0, offset=0, wcet=5, deadline=10, period=10)
    t2 = Task(1, offset=0, wcet=10, deadline=20, period=20)
    tasket = TaskSet([t1, t2])

    simulate(tasket, rate_monotonic, 100)


def test_deadline_missed():
    t1 = Task(0, offset=0, wcet=7, deadline=10, period=10)
    t2 = Task(1, offset=0, wcet=10, deadline=20, period=20)
    tasket = TaskSet([t1, t2])

    try:
        simulate(tasket, rate_monotonic, 100)
        assert False
    except exceptions.DeadlineMissedException:
        pass
