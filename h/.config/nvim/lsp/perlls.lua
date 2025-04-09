return {
    cmd = {
        'perl',
        '-MPerl::LanguageServer',
        '-e',
        'Perl::LanguageServer::run',
        '--',
        '--port 13603',
        '--nostdio 0',
    },
    settings = {
        perl = {
            perlCmd = 'perl',
            perlInc = ' ',
            fileFilter = { '.pm', '.pl' },
            ignoreDirs = '.git',
        },
    },
    filetypes = { 'perl' },
    single_file_support = true,
}
