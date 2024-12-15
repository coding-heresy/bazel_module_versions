
# shamelessly stolen from https://github.com/fmeum/version

# replace dashes and dots with underscores and convert all alphabetic
# characters to uppercase
def _to_identifier(name):
    return name.replace("-", "_").replace(".", "_").upper()

# repository rule implementation that generates a versions.bzl file
# containing named module versions
def _module_versions_repo_rule_impl(repository_ctx):
    repository_ctx.file("WORKSPACE.bazel")
    repository_ctx.file("BUILD.bazel")
    lines = [
        "{identifier}_VERSION = {version}".format(
            identifier = _to_identifier(name),
            version = repr(version),
        )
        for name, version in repository_ctx.attr.versions.items()
    ]
    repository_ctx.file("versions.bzl", "\n".join(sorted(lines)))

# create a repo rule containing all of the versions
_module_versions_repo_rule = repository_rule(
    implementation = _module_versions_repo_rule_impl,
    attrs = {
        "versions": attr.string_dict(),
    },
)

# implementation extracts all module versions into a map and calls
# _module_versions_repo_rule with it
def _module_versions_impl(module_ctx):
    _module_versions_repo_rule(
        name = "module_versions",
        versions = {
            module.name: module.version
            for module in module_ctx.modules
        },
    )

dependent_module_versions = module_extension(
    implementation = _module_versions_impl,
)
