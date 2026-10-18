"""Minimal Hello World application."""


def greet() -> str:
    return "Hello World"


def add(a: int, b: int) -> int:
    return a + b


if __name__ == "__main__":
    print(greet())
