const lightCodeTheme = require('prism-react-renderer/themes/github');
const darkCodeTheme = require('prism-react-renderer/themes/dracula');

// With JSDoc @type annotations, IDEs can provide config autocompletion
// noinspection JSAnnotator
/** @type {import('@docusaurus/types').DocusaurusConfig} */
(module.exports = {
  title: 'Takkan',
  tagline: 'Rapid Application Framework for Flutter',
  url: 'https://takkan.org',
  baseUrl: '/',
  onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'warn',
  favicon: 'img/takkan-logo-small.png',
  organizationName: 'takkan', // Usually your GitHub org/user name.
  projectName: 'takkan', // Usually your repo name.
  plugins:['remark-code-import'],

  presets: [
    [
      '@docusaurus/preset-classic',
      /** @type {import('@docusaurus/preset-classic').Options} */
      ({
        docs: {
          sidebarPath: require.resolve('./sidebars.js'),
          // Please change this to your repo.
          editUrl: 'https://gitlab.com/takkan/takkan_docs/-/edit/master/',
        },
        blog: {
          showReadingTime: true,
          // Please change this to your repo.
          editUrl: 'https://gitlab.com/takkan/takkan_docs/-/edit/master/',
        },
        theme: {
          customCss: require.resolve('./src/css/custom.css'),
        },
      }),
    ],
  ],

  themeConfig:
    /** @type {import('@docusaurus/preset-classic').ThemeConfig} */
    ({
      navbar: {
        title: 'Takkan',
        logo: {
          alt: 'Takkan Logo',
          src: 'img/takkan-logo-small.png',
        },
        items: [
          {
              type: 'doc',
              docId: 'intro',
              position: 'left',
              label: 'Overview',
          },
          {
              type: 'doc',
              docId: 'status',
              position: 'left',
              label: 'Status',
          },
          {
            type: 'doc',
            docId: 'tutorial-guide/tutorial',
            position: 'left',
            label: 'Tutorial',
          },
          {
              type: 'doc',
              docId: 'user-guide/intro',
              position: 'left',
              label: 'User Guide',
          },
          {
              type: 'doc',
              docId: 'developer-guide/intro',
              position: 'left',
              label: 'Developer Guide',
          },
          {to: '/blog', label: 'Blog', position: 'left'},
          {
            href: 'https://gitlab.com/takkan/takkan_docs/',
            label: 'GitLab',
            position: 'right',
          },
        ],
      },
      footer: {
        style: 'dark',
        links: [
          {
            title: 'Docs',
            items: [
              {
                  label: 'Overview',
                  to: '/docs/intro',
              },
              {
                  label: 'Status',
                  to: '/docs/status',
              },
              {
                label: 'Tutorial',
                to: '/docs/tutorial-guide/tutorial',
              },
              {
                  label: 'User Guide',
                  to: '/docs/user-guide/intro',
              },
              {
                  label: 'Developer Guide',
                  to: '/docs/developer-guide/intro',
              },
            ],
          },
          {
            title: 'Community',
            items: [
              {
                label: 'Stack Overflow',
                href: 'https://stackoverflow.com/questions/tagged/takkan',
              },
            ],
          },
          {
            title: 'More',
            items: [
              {
                label: 'Blog',
                to: '/blog',
              },
              {
                label: 'GitLab',
                href: 'https://gitlab.com/takkan/takkan_docs',
              },
            ],
          },
        ],
        copyright: `Copyright © ${new Date().getFullYear()} Takkan, Built with Docusaurus.`,
      },
      prism: {
        additionalLanguages: ['dart'],
        theme: lightCodeTheme,
        darkTheme: darkCodeTheme,
      },
    }),
});
