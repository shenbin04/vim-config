let b:ale_python_pylint_options = python#PYLintArgs()
let b:ale_python_flake8_options = '--ignore=E101,E501,W291,W292,W293'

nnoremap <buffer> gj :call python#OpenPythonFile()<CR>
nnoremap <buffer> gt :call python#OpenTestFile()<CR>
