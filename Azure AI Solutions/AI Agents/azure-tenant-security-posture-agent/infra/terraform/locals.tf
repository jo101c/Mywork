locals {
  report_container_name   = "reports"
  findings_container_name = "findings"
  storage_account_name    = "${substr(replace(var.storage_account_name, "-", ""), 0, 20)}${random_string.sa_suffix.result}"
}