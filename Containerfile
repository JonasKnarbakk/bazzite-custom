ARG IMAGE_VENDOR="${IMAGE_VENDOR:-ublue-os}"

FROM scratch AS ctx
COPY build-files /

FROM ghcr.io/ublue-os/bazzite:stable
COPY system-files/ /

# Setup Copr repos
RUN --mount=type=cache,dst=/var/cache/libdnf5 \
    --mount=type=cache,dst=/var/cache/rpm-ostree \
    --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,dst=/tmp \
    dnf5 -y copr enable wezfurlong/wezterm-nightly && \
    /ctx/cleanup

# Remove unneeded packages
RUN --mount=type=cache,dst=/var/cache/libdnf5 \
    --mount=type=cache,dst=/var/cache/rpm-ostree \
    --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,dst=/tmp \
    dnf5 -y remove \
        fish \
        cockpit-networkmanager \
        cockpit-podman \
        cockpit-selinux \
        cockpit-system \
        cockpit-storaged && \
    /ctx/cleanup

# Install new packages
RUN --mount=type=cache,dst=/var/cache/libdnf5 \
    --mount=type=cache,dst=/var/cache/rpm-ostree \
    --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,dst=/tmp \
    dnf5 -y install \
        autoconf \
        automake \
        bat \
        bison \
        black \
        bzip2-devel \
        ckb-next \
        clang \
        clang-analyzer \
        clang-tools-extra \
        compat-lua \
        fd-find \
        git-lfs \
        libffi-devel \
        libtool \
        libyaml-devel \
        lldb \
        luarocks \
        neovim \
        openssl-devel \
        pass \
        patch \
        picocom \
        python3-isort \
        readline-devel \
        ruby-devel \
        sqlite-devel \
        stow \
        tk-devel \
        wezterm \
        wl-clipboard \
        wofi \
        zlib \
        zlib-devel \
        zoxide \
        zsh \
        zsh-autosuggestions \
        zsh-syntax-highlighting && \
    /ctx/cleanup

# Cleanup and finalize
RUN --mount=type=cache,dst=/var/cache/libdnf5 \
    --mount=type=cache,dst=/var/cache/rpm-ostree \
    --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/finalize
