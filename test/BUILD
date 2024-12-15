
load('@bazel_skylib//rules:expand_template.bzl', 'expand_template')
load('@module_versions//:versions.bzl', 'BAZEL_MODULE_VERSIONS_VERSION')

expand_template(
    name = 'print_version_script',
    out = 'print_version.sh',
    substitutions = {
        '@MODULE_VERSION@': BAZEL_MODULE_VERSIONS_VERSION,
    },
    template = 'print_version.sh.in',
)

sh_binary(
    name = 'print_version',
    srcs = [':print_version_script'],
)
