# Local Execution Plan

## Goal

Make the Spring PetClinic application run locally and confirm it is working as the baseline before any AWS work.

## Steps

### 1. Go to the app repo

```bash
cd /home/ubuntu/Desktop/petclinic-platform/spring-petclinic-microservices
```

### 2. Start the application

```bash
docker compose up -d
```

### 3. Check running containers

```bash
docker compose ps
```

### 4. Verify the browser UI

Open:

```text
http://localhost:8080
```

Confirm:

- the UI loads
- the app is usable

### 5. Verify service discovery

Open:

```text
http://localhost:8761
```

Confirm:

- services are registering

### 6. Record baseline evidence

Capture screenshots of:

- `docker compose ps`
- browser UI
- Eureka page if needed

### 7. Update Jira

Short comment:

```text
Local Docker Compose baseline verified. Spring PetClinic starts successfully, the browser UI is reachable, and the core services are running. Screenshot attached.
```

## Done When

The local baseline is complete when:

- Docker Compose starts successfully
- the browser UI is reachable
- core services are running
- screenshot evidence is captured
- Jira is updated
