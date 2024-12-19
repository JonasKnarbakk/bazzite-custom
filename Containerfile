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
        zsh \
        neovim \
        stow \
	pass \
	wl-clipboard \
	wofi \
        picocom && \
    /usr/libexec/containerbuild/cleanup.sh && \
    ostree container commit

# Install Copr packages
RUN --mount=type=cache,dst=/var/cache/rpm-ostree \
    curl -Lo /etc/yum.repos.d/_copr_wezfurlong-wezterm-nightly.repo https://copr.fedorainfracloud.org/coprs/wezfurlong/wezterm-nightly/repo/fedora-"${FEDORA_MAJOR_VERSION}"/wezfurlong-wezterm-nightly-fedora-"${FEDORA_MAJOR_VERSION}".repo && \
    rpm-ostree install \
        wezterm && \
    /usr/libexec/containerbuild/cleanup.sh && \
    ostree container commit
