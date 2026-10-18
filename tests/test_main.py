from src.main import add, greet


def test_basic_addition():
    assert add(2, 3) == 5


def test_hello_world_message():
    assert greet() == "Hello World"
