# Secure and Minimal image of Hajk
# https://hub.docker.com/repository/docker/huggla/hajk-alpine

# =========================================================================
# Init
# =========================================================================
# ARGs (can be passed to Build/Final) <BEGIN>
ARG SaM_VERSION="dev"
ARG IMAGETYPE="application"
ARG CLONEGITS="https://github.com/hajkmap/Hajk.git"
ARG BUILDDEPS="npm"
ARG BUILDCMDS=\
"   cd Hajk/new-admin "\
"&& npm install "\
"&& npm --depth 8 update "\
"&& cd ../new-client "\
"&& npm install "\
"&& npm --depth 8 update "\
"&& cp -a ../new-client ../new-admin /finalfs/"
ARG RUNDEPS="npm"
ARG FINALCMDS=\
"   mv /usr/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm "\
"&& cd /usr/lib/node_modules/npm/bin "\
"&& ln -s ../../../../local/bin/npm npm-cli.js"
ARG STARTUPEXECUTABLES="/usr/local/bin/hajk.sh /usr/local/bin/npm /usr/bin/node"
# ARGs (can be passed to Build/Final) </END>

# Generic template (don't edit) <BEGIN>
FROM ${CONTENTIMAGE1:-scratch} as content1
FROM ${CONTENTIMAGE2:-scratch} as content2
FROM ${CONTENTIMAGE3:-scratch} as content3
FROM ${CONTENTIMAGE4:-scratch} as content4
FROM ${CONTENTIMAGE5:-scratch} as content5
FROM ${INITIMAGE:-${BASEIMAGE:-huggla/secure_and_minimal:$SaM_VERSION-base}} as init
# Generic template (don't edit) </END>

# =========================================================================
# Build
# =========================================================================
# Generic template (don't edit) <BEGIN>
FROM ${BUILDIMAGE:-huggla/secure_and_minimal:$SaM_VERSION-build} as build
FROM ${BASEIMAGE:-huggla/secure_and_minimal:$SaM_VERSION-base} as final
COPY --from=build /finalfs /
# Generic template (don't edit) </END>

# =========================================================================
# Final
# =========================================================================
ENV VAR_FINAL_COMMAND="hajk.sh"

# Generic template (don't edit) <BEGIN>
USER starter
ONBUILD USER root
# Generic template (don't edit) </END>
