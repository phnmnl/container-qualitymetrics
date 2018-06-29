################################################################################
### 
### [CONTAINER CORE FUNCTIONS]: 
###     install "Quality Metrics" Galaxy tool (and required third part softwares, libraries, ...).
### [NOTE]
###     please refer to README.md and about_docker.md files for further informations
### 
################################################################################

################################################################################
### fix parent containter
FROM container-registry.phenomenal-h2020.eu/phnmnl/rbase

################################################################################
### set author
MAINTAINER PhenoMeNal-H2020 Project ( phenomenal-h2020-users@googlegroups.com )

################################################################################
### set metadata
ENV TOOL_NAME=qualitymetrics
ENV TOOL_VERSION=2.2.11
ENV CONTAINER_VERSION=1.0
ENV CONTAINER_GITHUB=https://github.com/phnmnl/container-qualitymetrics

LABEL version="${CONTAINER_VERSION}"
LABEL software.version="${TOOL_VERSION}"
LABEL software="${TOOL_NAME}"
LABEL base.image="ubuntu:16.04"
LABEL description="A filter for samples and/or variables."
LABEL website="${CONTAINER_GITHUB}"
LABEL documentation="${CONTAINER_GITHUB}"
LABEL license="${CONTAINER_GITHUB}"
LABEL tags="Metabolomics"

################################################################################
# Install
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y libcurl4-openssl-dev libxml2-dev git make gcc && \
	git clone --recurse-submodules --single-branch -b v${TOOL_VERSION} https://github.com/workflow4metabolomics/qualitymetrics.git /files/qualitymetrics  && \
    echo "r <- getOption('repos'); r['CRAN'] <- 'http://cran.us.r-project.org'; options(repos = r);" > ~/.Rprofile  && \
    R -e "install.packages('batch', dep=TRUE)" && \
    R -e "source('http://www.bioconductor.org/biocLite.R'); biocLite('ropls')" && \
    chmod a+x /files/qualitymetrics/qualitymetrics_wrapper.R && \
    apt-get purge -y git make gcc && \
    apt-get clean  && \
    apt-get autoremove -y  && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ /tmp/* /var/tmp/*

# Make tool accessible through PATH
ENV PATH = $PATH:/files/qualitymetrics

################################################################################
### Define script ENTRYPOINT or container CMD
ENTRYPOINT ["/files/qualitymetrics/qualitymetrics_wrapper.R"]

### [END]
################################################################################
