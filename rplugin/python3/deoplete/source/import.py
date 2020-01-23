import os
import re
import typing

from deoplete.base.source import Base
from deoplete.util import expand, Nvim, UserContext, Candidates


class Source(Base):
    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)

        self.name = 'import'
        self.mark = '[I]'
        self.rank = 500
        self.input_pattern = '^import.*from.*'
        self.events: typing.List[str] = ['InsertEnter']

    def gather_candidates(self, context: UserContext) -> Candidates:
        roots = [root for root in self.vim.command_output('echo &path').split(',') if root]

        root = roots[-1]

        input_str = re.sub(r'.*[\'"]', '', context['input'])

        data = re.split('/', input_str)
        data = [os.path.join(root, '/'.join(data[:i])) for i in range(len(data))]
        longest_path = data[-1]

        if (
            os.path.isfile(longest_path)
            or os.path.isfile(longest_path + '.js')
            or os.path.isfile(longest_path + '.jsx')
        ):
            return []

        existing_paths = [d for d in data if os.path.isdir(d)]

        current_dir = existing_paths[-1] if existing_paths else root

        contents: typing.List[typing.Any] = [[], []]
        try:
            for item in sorted(os.listdir(current_dir), key=str.lower):
                if item[0] != '.':
                    is_dir = os.path.isdir(os.path.join(current_dir, item))
                    item = re.sub(r'.jsx?$', '', item)
                    contents[is_dir].append(item)
        except PermissionError:
            pass

        files, dirs = contents
        return [{'word': x, 'abbr': x + '/'} for x in dirs] + [{'word': x} for x in files]
