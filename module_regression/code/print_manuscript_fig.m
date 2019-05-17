function print_manuscript_fig(title_str)
    format_str = '-djpeg';
    res_str = '-r300';
    print(sprintf('figures/manuscript/%s',title_str),format_str,res_str);
end