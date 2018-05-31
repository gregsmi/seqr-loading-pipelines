import os


def run(command):
    print(command)
    os.system(command)


os.chdir(os.path.join(os.path.dirname(__file__), ".."))

for vcf_path in [
    "gs://seqr-reference-data/GRCh37/MPC/fordist_constraint_official_mpc_values.vcf.gz",
    "gs://seqr-reference-data/GRCh38/MPC/fordist_constraint_official_mpc_values.liftover.GRCh38.vcf.gz"
]:
    run(" ".join([
        "python gcloud_dataproc/run_script.py",
        "--cluster mpc",
        "hail_scripts/convert_vcf_to_vds.py",
        "{vcf_path}",
    ]).format(**locals()))
