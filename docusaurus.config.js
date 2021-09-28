const lightCodeTheme = require('prism-react-renderer/themes/github');
const darkCodeTheme = require('prism-react-renderer/themes/dracula');

// With JSDoc @type annotations, IDEs can provide config autocompletion
// noinspection JSAnnotator
/** @type {import('@docusaurus/types').DocusaurusConfig} */
(module.exports = {
  title: 'Precept',
  tagline: 'Application Framework for Flutter',
  url: 'https://preceptblog.co.uk',
  baseUrl: '/',
  onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'warn',
  favicon: 'img/precept-logo-small.png',
  organizationName: 'precept1', // Usually your GitHub org/user name.
  projectName: 'precept_client', // Usually your repo name.

  presets: [
    [
      '@docusaurus/preset-classic',
      /** @type {import('@docusaurus/preset-classic').Options} */
      ({
        docs: {
          sidebarPath: require.resolve('./sidebars.js'),
          // Please change this to your repo.
          editUrl: 'https://gitlab.com/precept1/precept_docs/-/edit/master/',
        },
        blog: {
          showReadingTime: true,
          // Please change this to your repo.
          editUrl:
            'https://gitlab.com/precept1/precept_docs/-/edit/master/',
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
        title: 'Precept',
        logo: {
          alt: 'Precept Logo',
          src: 'img/precept-logo-small.png',
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
            docId: 'tutorial/brief',
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
            href: 'https://gitlab.com/precept1/precept_docs/',
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
                  to: '/intro',
              },
              {
                label: 'Tutorial',
                to: '/docs/tutorial/brief',
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
                href: 'https://stackoverflow.com/questions/tagged/precept',
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
                href: 'https://gitlab.com/precept1/precept_docs',
              },
            ],
          },
        ],
        copyright: `Copyright © ${new Date().getFullYear()} Precept, Built with Docusaurus.`,
      },
      prism: {
        additionalLanguages: ['dart'],
        theme: lightCodeTheme,
        darkTheme: darkCodeTheme,
      },
    }),
});
