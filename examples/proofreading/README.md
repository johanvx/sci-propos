# Example: proofreading a Word draft

A test of the `scientific-writing` skill's proofreading mode on a short,
deliberately flawed laboratory report.

| File | |
|---|---|
| `draft.docx` | The draft, on the sci-propos Word template |
| `draft-reviewed.docx` | The same file with 12 Word comments, one per problem |
| `previews/draft-reviewed.png` | The reviewed page, comments in the margin |

Each comment names the rule in brackets, explains it in a sentence, and
suggests a fix, in the order the skill reviews: organization and emphasis
(title, summary), then grammar (run-on, dangling modifier, parallelism),
punctuation (comma after an introductory clause), usage (comprise, data,
affect/effect, fewer/less, its) and style (ambiguous "this", "obvious").
The text itself is unchanged: the author decides what to accept.

The reviewed file was made with python-docx (`Document.add_comment` on the
run that holds each problem), the same way the skill returns comments on
any `.docx`.
