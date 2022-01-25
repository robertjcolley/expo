import { css } from '@emotion/react';
import { theme, palette } from '@expo/styleguide';
import NextLink from 'next/link';
import React from 'react';

import DocumentationSidebarRightLink from './DocumentationSidebarRightLink';

import { findHeadingId, useTableOfContents } from '~/common/use-table-of-contents';
import { paragraph } from '~/components/base/typography';
import * as Constants from '~/constants/theme';

const STYLES_SIDEBAR = css`
  padding: 20px 24px 24px 24px;
  width: 280px;

  @media screen and (max-width: ${Constants.breakpoints.mobile}) {
    width: 100%;
  }
`;

const STYLES_LINK = css`
  ${paragraph}
  color: ${theme.text.secondary};
  transition: 50ms ease color;
  font-size: 14px;
  display: block;
  text-decoration: none;
  margin-bottom: 6px;
  cursor: pointer;

  :hover {
    color: ${theme.link.default};
  }
`;

const STYLES_LINK_ACTIVE = css`
  color: ${theme.link.default};
`;

type Props = {
  maxNestingDepth?: number;
  selfRef?: React.RefObject<any>;
  contentRef?: React.RefObject<any>;
};

export default function DocumentationSidebarRight(props: Props) {
  const { headings, activeId } = useTableOfContents({
    root: props.contentRef?.current?.getScrollRef()?.current,
  });

  return (
    <nav css={STYLES_SIDEBAR} data-sidebar>
      {headings.map(heading => {
        const headingId = findHeadingId(heading);

        return (
          <NextLink href={`#${headingId}`} key={headingId} passHref>
            <a css={[STYLES_LINK, headingId === activeId && STYLES_LINK_ACTIVE]}>
              {heading.textContent}
            </a>
          </NextLink>
        )
      })}
    </nav>
  );
}
