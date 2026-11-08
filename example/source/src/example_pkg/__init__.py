"""A tiny package used to smoke-test API reference generation."""

__all__ = ["Greeter", "add"]


def add(a: int, b: int) -> int:
    """Add two integers.

    Args:
        a: The first operand.
        b: The second operand.

    Returns:
        The sum of `a` and `b`.
    """
    return a + b


class Greeter:
    """Greets people by name.

    Args:
        greeting: The word used to greet.
    """

    def __init__(self, greeting: str = "Hello") -> None:
        self.greeting = greeting

    def greet(self, name: str) -> str:
        """Return a greeting for `name`.

        Args:
            name: Who to greet.

        Returns:
            The greeting.
        """
        return f"{self.greeting}, {name}!"
