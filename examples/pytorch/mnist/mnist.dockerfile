FROM docker.1ms.run/easydl/dlrover:ci AS builder

WORKDIR /dlrover
COPY ./ .
RUN sh scripts/build_wheel.sh

FROM docker.1ms.run/easydl/dlrover-train:torch201-cpu-py38  AS base

WORKDIR /dlrover

RUN apt-get update && apt-get install -y sudo

COPY --from=builder /dlrover/dist/dlrover-*.whl /
RUN pip install /*.whl --extra-index-url=https://pypi.org/simple && rm -f /*.whl

COPY ./examples ./examples
