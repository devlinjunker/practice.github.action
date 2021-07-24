FROM ubuntu:18.04

COPY find-todo.sh /find-todo.sh

ENTRYPOINT ["/find-todo.sh"]