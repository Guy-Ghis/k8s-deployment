# Use the official MkDocs image as a base
FROM squidfunk/mkdocs-material:latest

# Set the working directory
WORKDIR /docs

# Copy your MkDocs project files into the container
COPY . .

# Expose the port MkDocs will run on
EXPOSE 8000

# Command to run MkDocs
CMD ["mkdocs", "serve", "--dev-addr=0.0.0.0:8000"]
