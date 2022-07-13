import { css } from '@emotion/react';
import { theme } from '@expo/styleguide';

export const globalExtras = css`
  img.wide-image {
    max-width: 900px;
  }

  img[src*="https://placehold.it/15"]
  {
    width: 15px !important;
    height: 15px !important;
  }

  .react-player > video {
    outline: none;
  }

  .strike {
    text-decoration: line-through;
  }

  // TODO: investigate why some style is forcing nested ordered lists to have
  // 1rem bottom margin!
  ul ul,
  ol ul {
    margin-bottom: 0 !important;
  }

  // note(simek): we need to leave this styling for the Expo CLI
  // autogenerated content (at least for now)

  details summary {
    cursor: pointer;

    &:hover {
      h4,
      div {
        color: ${theme.text.secondary};
      }
    }

    ::marker {
      color: ${theme.icon.default};
      margin-right: 8px;
    }

    h4 {
      display: inline-block;
      padding-left: 4px;
    }
  }
`;
