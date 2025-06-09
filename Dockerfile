# 1. Base image with R 4.4.1 and preinstalled system deps
FROM rocker/verse:4.4.1

ENV TZ=America/Los_Angeles

# 2. Set working directory and copy project files
WORKDIR /home/rstudio/project
COPY . .

# 3. Install renv and restore from lockfile
RUN install2.r renv \
 && Rscript -e "renv::consent(provided = TRUE); renv::restore(lockfile = '/home/rstudio/project/renv.lock')"

# 4. Set permissions for RStudio user
RUN chown -R rstudio:rstudio /home/rstudio/project \
 && chmod -R u+w /home/rstudio/project

# 5. Auto-open .Rproj in RStudio
RUN echo 'setHook("rstudio.sessionInit", function(newSession) { \
  if (newSession && is.null(rstudioapi::getActiveProject())) { \
    rstudioapi::openProject("/home/rstudio/project/resprout-medshrub.Rproj") \
  } \
}, action = "append")' >> /home/rstudio/.Rprofile \
 && chown rstudio:rstudio /home/rstudio/.Rprofile

# 6. Default CMD to launch RStudio Server
CMD ["/init"]
