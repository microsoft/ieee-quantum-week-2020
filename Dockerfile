FROM mcr.microsoft.com/quantum/iqsharp-base:0.12.20082513
ENV IQSHARP_HOSTING_ENV=ieee-quantum-week-2020-binder

# Make sure the contents of our repo are in ${HOME}.
# These steps are required for use on mybinder.org.
USER root
COPY . ${HOME}
RUN chown -R ${USER} ${HOME}

# Install RISE.
RUN pip install rise
RUN pip install ipykernel
RUN pip install scipy
RUN pip install matplotlib
RUN pip install seaborn
RUN pip install pyscf

# Finish by dropping back to the notebook user.
USER ${USER}
