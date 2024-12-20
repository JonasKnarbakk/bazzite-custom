FROM ghcr.io/ublue-os/bazzite:stable

# Remove unneeded packages
RUN --mount=type=cache,dst=/var/cache/rpm-ostree \
    rpm-ostree override remove \
        fish \
        cockpit-networkmanager \
        cockpit-podman \
        cockpit-selinux \
        cockpit-system \
        cockpit-navigator \
        cockpit-storaged && \
    /usr/libexec/containerbuild/cleanup.sh && \
    ostree container commit

# Install new packages
RUN --mount=type=cache,dst=/var/cache/rpm-ostree \
    rpm-ostree install \
        bat \
        black \
        bzip2-devel \
        clang \
        clang-analyzer \
        clang-tools-extra \
        fd-find \
        libffi-devel \
        lua \
        luarocks \
        neovim \
        openssl-devel \
        pass \
        picocom \
        python3-isort \
        readline-devel \
        ruby \
        ruby-devel \
        sqlite-devel \
        stow \
        tk-devel \
        wl-clipboard \
        wofi \
        zoxide \
        zsh \
        zsh-autosuggestions \
        zsh-syntax-highlighting && \
    /usr/libexec/containerbuild/cleanup.sh && \
    ostree container commit

# Install Copr packages
RUN --mount=type=cache,dst=/var/cache/rpm-ostree \
    curl -Lo /etc/yum.repos.d/_copr_wezfurlong-wezterm-nightly.repo https://copr.fedorainfracloud.org/coprs/wezfurlong/wezterm-nightly/repo/fedora-"${FEDORA_MAJOR_VERSION}"/wezfurlong-wezterm-nightly-fedora-"${FEDORA_MAJOR_VERSION}".repo && \
    rpm-ostree install \
        wezterm && \
    /usr/libexec/containerbuild/cleanup.sh && \
    ostree container commit
