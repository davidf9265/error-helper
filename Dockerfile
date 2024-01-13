# Specify the base image
FROM mcr.microsoft.com/dotnet/sdk:8.0.101 AS build-env

# install node 20.9.0
ENV NODE_VERSION=20.9.0
RUN apt install -y curl
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN node --version
RUN npm --version

# Set the working directory
WORKDIR /app

# Copy the package.json and package-lock.json files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the application code
COPY . .

# Set the default value for the APP_NAME environment variable
ENV APP_NAME errors-api

# Check the value of the APP_NAME environment variable and run the corresponding command
CMD if [ "$APP_NAME" = "errors-api" ]; then \
    npm run start-errors-api; \
    elif [ "$APP_NAME" = "PaymentPlayground" ]; then \
    npm run start-payment-playground; \
    else \
    echo "Invalid APP_NAME specified"; \
    exit 1; \
    fi