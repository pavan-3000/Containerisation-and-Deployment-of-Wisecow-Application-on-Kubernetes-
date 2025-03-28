FROM ubuntu:latest

# Set environment variables
ENV SRVPORT=4499
ENV PATH="/usr/games:${PATH}"

# Install dependencies
RUN apt-get update && apt-get install -y \
    fortune-mod cowsay netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

# Copy the script into the container
COPY wisecow.sh /wisecow.sh

# Give execution permissions
RUN chmod +x /wisecow.sh

# Expose the server port
EXPOSE 4499

# Run the script
CMD ["/wisecow.sh"]

