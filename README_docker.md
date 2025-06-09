# Dockerized RStudio Environment

This repository contains a Dockerfile that builds a reproducible RStudio Server environment using `rocker/verse:4.4.1`. This image includes R 4.4.1, RStudio Server, and common system dependencies. During the build process, all required R packages are restored from `renv.lock` (e.g., `piecewiseSEM` 2.1.2), and the project is configured to auto-open `resprout-medshrub.Rproj` on startup.

---

## Prerequisites

- Docker installed on your machine  
- On Apple Silicon (M1/M2), use `--platform=linux/amd64` to ensure compatibility with x86-based docker images

---

## 1. Building the Docker Image

### 1.1. Build using cache (fast)

```bash
cd /path/to/resprout-medshrub-analysis
docker build --platform=linux/amd64 -t my-rstudio-env .
```

- `--platform=linux/amd64` ensures an x86-compatible image (required on Apple Silicon).
- `-t my-rstudio-env` tags the newly built image.
- This reuses cached layers if nothing has changed.

### 1.2. Build with no cache (force reinstall of every layer)

```bash
cd /path/to/resprout-medshrub-analysis
docker build --no-cache --platform=linux/amd64 -t my-rstudio-env .
```

- `--no-cache` forces Docker to re-run every `RUN` step, reinstalling all R packages from scratch.
- Useful if you modified the Dockerfile or updated `renv.lock`.

---

## 2. Running the Container

Once built, start the RStudio Server container:

```bash
docker run \
  --platform=linux/amd64 \
  -d \
  -p 8787:8787 \
  -e PASSWORD=rstudio \
  --name resprout_rstudio_container \
  my-rstudio-env
```

- `-d` runs the container in detached mode.
- `-p 8787:8787` maps RStudio Server to your local port.
- `-e PASSWORD=rstudio` sets the login password.
- `--name` assigns a name to the container.

---

### 3. Accessing RStudio Server
Open your browser to:
```arduino
http://localhost:8787
```
Log in with:

```makefile
Username: rstudio
Password: rstudio
```


The RStudio session will automatically open `resprout-medshrub.Rproj`, thanks to the .Rprofile hook added to the container's RStudio user during the image build process.  
In the Console, you can verify:

```r
here::here()         # → "/home/rstudio/project"
library(piecewiseSEM)  # version 2.1.2
```

---

## 4. Stopping and Removing the Container

### 4.1. Stop the container

```bash
docker stop resprout_rstudio_container
```

### 4.2. Remove the container

```bash
docker rm resprout_rstudio_container
```

If you plan to rebuild or re-run from scratch, stop and remove the old container first.

---

## 5. (Optional) Clean Up Old Images

To delete the `my-rstudio-env` image when you're done:

```bash
docker rmi my-rstudio-env
```

---

## 6. Summary of Key Commands

```bash
# Build (with cache):
docker build --platform=linux/amd64 -t my-rstudio-env .

# Build (no cache):
docker build --no-cache --platform=linux/amd64 -t my-rstudio-env .

# Run:
docker run --platform=linux/amd64 -d -p 8787:8787 -e PASSWORD=rstudio \
  --name resprout_rstudio_container my-rstudio-env

# Access:
# Visit http://localhost:8787 (login: rstudio / rstudio)

# Stop:
docker stop resprout_rstudio_container

# Remove:
docker rm resprout_rstudio_container

# Remove image:
docker rmi my-rstudio-env
```
