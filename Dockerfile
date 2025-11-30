FROM pytorch/pytorch:2.7.1-cuda12.8-cudnn9-runtime

ARG HOME=/root
ENV HOME=$HOME
COPY . $HOME/nanochat
WORKDIR $HOME/nanochat

ENV OMP_NUM_THREADS=1
ENV NANOCHAT_BASE_DIR="$HOME/.cache/nanochat"
ENV UV_INSTALL_DIR=/root/.local/bin
ENV PATH="${UV_INSTALL_DIR}:${PATH}"
RUN mkdir -p $NANOCHAT_BASE_DIR

RUN curl -LsSf https://astral.sh/uv/install.sh | sh
RUN uv venv
RUN uv sync --extra gpu

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

RUN ./speedrun-tokenizer-build.sh

ENTRYPOINT ["./speedrun-run.sh"]

