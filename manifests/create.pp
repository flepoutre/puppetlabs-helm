# Defined Type helm::chart::create
#
# @summary
#   Creates a new Helm chart.
#
# @param chart_name
#   The name of the Helm chart.
#   Defaults to `undef`.
# 
# @param chart_path
#   The location of the Helm chart.
#   If the directory in the path does not exist, Helm attempts to create it. If the directory and the files already exist, only the conflicting files are overwritten.
# 
# @param debug
#   Specifies whether to enable verbose output.
#   Values `true`, `false`.
# 
# @param env
#   Sets the environment variables for Helm to connect to the Kubernetes cluster.
# 
# @param home
#   The location of your Helm configuration. This value overrides `$HELM_HOME`.
# 
# @param host
#   Address of Tiller. This value overrides `$HELM_HOST`.
#
# @param kube_context
#   The name of the kubeconfig context.
# 
# @param path
#   The PATH variable used for exec types.
# 
# @param starter
#   Value for the starter chart.
# 
# @param tiller_namespace
#   Namespace of Tiller.
# 
define helm::create (
  Optional[String] $chart_name       = undef,
  Optional[String] $chart_path       = undef,
  Boolean $debug                     = false,
  Optional[Array] $env               = undef,
  Optional[String] $home             = undef,
  Optional[String] $host             = undef,
  Optional[String] $kube_context     = undef,
  Optional[Array] $path              = undef,
  Optional[String] $starter          = undef,
  Optional[String] $tiller_namespace = undef,
) {
  include helm::params

  $helm_create_flags = helm_create_flags({
      chart_name => $chart_name,
      chart_path => $chart_path,
      debug => $debug,
      home => $home,
      host => $host,
      kube_context => $kube_context,
      starter => $starter,
      tiller_namespace => $tiller_namespace,
  })

  $exec_chart = "helm create ${helm_create_flags}"

  exec { "helm create ${chart_name}" :
    command     => $exec_chart,
    environment => $env,
    path        => $path,
    timeout     => 0,
    creates     => "${chart_path}/${chart_name}",
  }
}
