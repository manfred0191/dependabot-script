FROM ghcr.io/dependabot/dependabot-core:0.215.0

ARG CODE_DIR=/home/dependabot/dependabot-script
RUN mkdir -p ${CODE_DIR}

# Copy Gemfile and Gemfile.lock first to leverage Docker caching
COPY --chown=dependabot:dependabot Gemfile Gemfile.lock ${CODE_DIR}/

WORKDIR ${CODE_DIR}

# Install dependencies
RUN bundle config set --local path "vendor" \
    && bundle install --jobs 4 --retry 3

# Copy the rest of the application code
COPY --chown=dependabot:dependabot . ${CODE_DIR}

CMD ["bundle", "exec", "ruby", "./generic-update-script.rb"]
