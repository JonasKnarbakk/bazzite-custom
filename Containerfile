FROM ghcr.io/ublue-os/bazzite:stable

COPY system-files/ /

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
        wl-clipboard \
        wofi \
        zlib \
        zlib-devel \
        zoxide \
        zsh \
        zsh-autosuggestions \
        zsh-syntax-highlighting && \
    /usr/libexec/containerbuild/cleanup.sh && \
    ostree container commit

# Install Copr packages
RUN --mount=type=cache,dst=/var/cache/rpm-ostree \
    curl -Lo /etc/yum.repos.d/_copr_wezfurlong-wezterm-nightly.repo https://copr.fedorainfracloud.org/coprs/wezfurlong/wezterm-nightly/repo/fedora-"${FEDORA_MAJOR_VERSION}"/wezfurlong-wezterm-nightly-fedora-"${FEDORA_MAJOR_VERSION}".repo && \
    curl -Lo /etc/yum.repos.d/_copr_lizardbyte-sunshine-stable.repo https://copr.fedorainfracloud.org/coprs/lizardbyte/stable/repo/fedora-"${FEDORA_MAJOR_VERSION}"/lizardbyte-stable-fedora-"${FEDORA_MAJOR_VERSION}".repo && \
    rpm-ostree install \
        wezterm \
        sunshine && \
    /usr/libexec/containerbuild/cleanup.sh && \
    ostree container commit
