#!/bin/sh

phpcs --version

cd "$GITHUB_WORKSPACE"

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

cd "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}" || exit 1

if [ "${INPUT_REPORTER}" == 'github-pr-review' ]; then
  phpcs --report=json ${INPUT_PHPCS_FLAGS:-'.'} \
    | jq -r ' .files | to_entries[] | .key as $path | .value.messages[] as $msg | "\($path):\($msg.line):\($msg.column):`\($msg.source)`<br>\($msg.message)" ' \
    | reviewdog -efm="%f:%l:%c:%m" \
      -name="${INPUT_TOOL_NAME}" \
      -reporter=github-pr-review \
      -filter-mode="${INPUT_FILTER_MODE}" \
      -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
      -level="${INPUT_LEVEL}" \
      ${INPUT_REVIEWDOG_FLAGS}
else
  # github-pr-check,github-check (GitHub Check API) doesn't support markdown annotation.
  phpcs --report=checkstyle ${INPUT_PHPCS_FLAGS:-'.'} \
    | reviewdog -f="checkstyle" \
      -name="${INPUT_TOOL_NAME}" \
      -reporter="${INPUT_REPORTER:-github-pr-check}" \
      -filter-mode="${INPUT_FILTER_MODE}" \
      -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
      -level="${INPUT_LEVEL}" \
      ${INPUT_REVIEWDOG_FLAGS}
fi
