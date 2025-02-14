# Docker Debug

Docker Debug is a feature that allows developers to troubleshoot and debug their applications by running containers with additional debugging tools and utilities, typically not included in production images.

- Shell access: Docker Debug provides a robust debug shell equipped with essential tools by default, such as Vim, Nano, htop, curl, and more. This makes it easy to inspect and modify container contents.
- Support for slim containers: Even if a container does not include a shell, Docker Debug allows you to attach a debug shell, facilitating troubleshooting without needing to modify the container image.
- [Docker Debug documentation](https://docs.docker.com/reference/cli/docker/debug/)


___
[◀️ Previous](./01-dockerize.md) | [Next: Testcontainers ▶️](./03-testcontainers.md)