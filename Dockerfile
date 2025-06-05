FROM jenkins/jenkins:lts-jdk17
USER root

# 1. Identificar a versão correta do Debian
RUN apt-get update && apt-get install -y lsb-release

# 2. Configurar o repositório Docker corretamente
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

# 3. Instalar Docker CLI (não o daemon)
RUN apt-get update && \
    apt-get install -y docker-ce-cli

# 4. Alternativa caso o método acima falhe
RUN if ! apt-get install -y docker-ce-cli; then \
        echo "Falling back to manual Docker CLI installation"; \
        curl -fsSL https://download.docker.com/linux/static/stable/$(uname -m | sed 's/x86_64/x86_64/')/docker-20.10.23.tgz | tar -xzC /usr/local/bin --strip-components=1; \
    fi

# 5. Configurar permissões
RUN groupadd -g 1000 docker && \
    useradd -u 1000 -g jenkins -d /var/jenkins_home jenkins
RUN usermod -aG docker jenkins && \
    chmod 666 /var/run/docker.sock || true
RUN mkdir -p /var/jenkins_home && \
    chown -R 1000:1000 /var/jenkins_home && \
    chmod -R 755 /var/jenkins_home

# 6. Voltar para o usuário jenkins
USER jenkins
