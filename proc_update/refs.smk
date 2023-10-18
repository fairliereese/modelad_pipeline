configfile: 'config.yml'

################################################################################
######################## Ref. download / proc ##################################
################################################################################
use rule dl as dl_fa with:
    params:
        link = lambda wc:config['ref']['fa_link']
    output:
        out = temporary(config['ref']['fa_gz'])

use rule gunzip as gz_fa with:
    input:
        gz = config['ref']['fa_gz']
    output:
        out = config['ref']['fa']

use rule dl as dl_annot with:
    params:
        link = lambda wc:config['ref']['gtf_link']
    output:
        out = temporary(config['ref']['gtf_gz'])

use rule gunzip as gz_annot with:
    input:
        gz = config['ref']['gtf_gz']
    output:
        out = config['ref']['gtf']

# rule mkref_spike_gtf:
#     input:
#         sirv = config['ref']['spike']['sirv_gtf'],
#         ercc = config['ref']['spike']['ercc_gtf'],
#         gtf = config['ref']['gtf']
#     resources:
#         mem_gb = 16,
#         threads = 2
#     output:
#         all = config['ref']['talon']['gtf']
#     shell:
#         """
#         cat {input.gtf} > {output.all}
#         cat {input.sirv} >> {output.all}
#         cat {input.ercc} >> {output.all}
#         """
#
# rule mkref_spike_fa:
#     input:
#         sirv = config['ref']['spike']['sirv_fa'],
#         ercc = config['ref']['spike']['ercc_fa'],
#         fa = config['ref']['fa']
#     resources:
#         threads = 1,
#         mem_gb = 4
#     output:
#         cat_fa = config['ref']['talon']['fa']
#     shell:
#         """
#         cat {input.fa} >> {output.cat_fa}
#         cat {input.sirv} >> {output.cat_fa}
#         cat {input.ercc} >> {output.cat_fa}
#         """

rule mkref_chrom_sizes:
    input:
        fa = config['ref']['fa']
    resources:
        threads = 1,
        mem_gb = 8
    output:
        chrom_sizes = config['ref']['chrom_sizes']
    shell:
        """
        faidx {input.fa} -i chromsizes > {output.chrom_sizes}
        """

# installable from here: https://github.com/MuhammedHasan/gencode_utr_fix
rule mkref_utr_fix_gtf:
    input:
        gtf = config['ref']['gtf']
    resources:
        threads = 1,
        mem_gb = 8
    output:
        gtf = config['ref']['lapa']['gtf']
    shell:
        """
        gencode_utr_fix \
            --input_gtf {input.gtf} \
            --output_gtf {output.gtf}
        """