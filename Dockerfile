# =========================================================================
# Init
# =========================================================================
# ARGs (can be passed to Build/Final) <BEGIN>
ARG SaM_VERSION="1.1-edge"
ARG TAG="20191112"
ARG IMAGETYPE="application"
ARG INITIMAGE="node:alpine"
ARG CLONEGITS="https://github.com/hajkmap/Hajk.git"
ARG BUILDCMDS=\
"   npm install npm@latest -g "\
"&& cd Hajk/new-admin "\
"&& npm install "\
"&& npm --depth 8 update "\
"&& cd ../new-client "\
"&& npm install "\
"&& npm --depth 8 update "\
"&& cp -a ../new-client ../new-admin /finalfs/"
ARG STARTUPEXECUTABLES="/usr/local/bin/hajk.sh"
# ARGs (can be passed to Build/Final) </END>

# Generic template (don't edit) <BEGIN>
FROM ${CONTENTIMAGE1:-scratch} as content1
FROM ${CONTENTIMAGE2:-scratch} as content2
FROM ${CONTENTIMAGE3:-scratch} as content3
FROM ${CONTENTIMAGE4:-scratch} as content4
FROM ${CONTENTIMAGE5:-scratch} as content5
FROM ${INITIMAGE:-${BASEIMAGE:-huggla/sam_$SaM_VERSION:base-$TAG}} as init
# Generic template (don't edit) </END>

RUN exec > /build.log 2>&1 \
 && set -ex +fam \
 && mkdir /environment /tmp/onbuild \
 && (find . -type l ! -path './tmp/*' ! -path './var/cache/*' ! -path './proc/*' ! -path './sys/*' ! -path './dev/*' -exec sh -c 'echo -n "$(echo "{}" | cut -c 2-)>"' \; -exec readlink "{}" \; && find . -type f ! -path './tmp/*' ! -path './var/cache/*' ! -path './proc/*' ! -path './sys/*' ! -path './dev/*' -exec md5sum "{}" \; | awk '{first=$1; $1=""; print $0">"first}' | sed 's|^ [.]||') | sort -u - > /tmp/onbuild/exclude.filelist \
 && tar -c -z -f /environment/onbuild.tar.gz -C /tmp onbuild

# =========================================================================
# Build
# =========================================================================
# Generic template (don't edit) <BEGIN>
FROM ${BUILDIMAGE:-huggla/sam_$SaM_VERSION:build-$TAG} as build
FROM ${BASEIMAGE:-huggla/sam_$SaM_VERSION:base-$TAG} as final
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
