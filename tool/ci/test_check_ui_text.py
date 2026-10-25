import unittest

from check_ui_text import untranslated


class UiTextCheckTest(unittest.TestCase):
    def test_display_fields_and_defaults_are_checked(self):
        for source in ["Text('Hello')", 'title: "Hello"', "hintText: 'Try again'", "this.action = 'Save'"]:
            with self.subTest(source=source):
                self.assertEqual(len(list(untranslated(source))), 1)

    def test_interpolated_counts_still_need_translation(self):
        self.assertEqual(list(untranslated("Text('$count messages')")), [(1, '$count messages')])

    def test_runtime_content_is_not_inspected(self):
        self.assertEqual(list(untranslated('Text(message.subject)')), [])
        self.assertEqual(list(untranslated('label: server.displayName')), [])

    def test_existing_lookups_are_accepted(self):
        self.assertEqual(list(untranslated("Text(tr(context, 'mail.search'))")), [])
        self.assertEqual(list(untranslated("this.action = 'common.save'")), [])
        self.assertEqual(list(untranslated("Text('${tr(context, 'status.live')} · $host')")), [])

    def test_technical_examples_and_protocols_are_preserved(self):
        for source in ["Text('TLS')", "hintText: 'name@example.com'", "hint: '90m'", "Text('${value} ms')"]:
            with self.subTest(source=source):
                self.assertEqual(list(untranslated(source)), [])

    def test_context_words_in_address_examples_are_checked(self):
        self.assertEqual(len(list(untranslated("hint: 'name@example.com or @example.com'"))), 1)


if __name__ == '__main__':
    unittest.main()
