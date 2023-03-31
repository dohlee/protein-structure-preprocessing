configfile: 'config.yaml'

pids = [l.strip() for l in open(config['pdb_list']).readlines()]

ALL = []
ALL.append(
    expand('result/01_reduce/{pid}.pdb', pid=pids)
)

rule all:
    input: ALL

rule fetch_pdb:
    output: 'pdb/{pid}.pdb'
    shell:
        'wget https://files.rcsb.org/download/{wildcards.pid}.pdb '
        '-qO {output}'

rule reduce:
    input:
        'pdb/{pid}.pdb'
    output:
        'result/01_reduce/{pid}.pdb'
    params:
        bin = config['reducebin'],
        db = config['reducedb'],
    shell:
        '{params.bin} -BUILD '
        '-DB {params.db} '
        '-Quiet '
        '{input} > {output}'

