// Template: stories for a shared component (Storybook 9+, CSF3).
// Rules:
// - One named export per state; delete the stories for states the component does not have.
// - Use real copy in args.
// - Wrap dark mode and density in a decorator so no particular addon is required.
// - To render hover / active statically, install storybook-addon-pseudo-states and uncomment the Hover story.
// - Tag stories that should not be screenshot-compared with "skip-visual".
import type { Meta, StoryObj } from "@storybook/react-vite"; // Use the project's framework package, for example @storybook/nextjs-vite
import { expect, fn } from "storybook/test";

import { Button } from "./button"; // TODO(design): the real component

const meta = {
  title: "UI/Button", // TODO(design)
  component: Button,
  tags: ["autodocs"],
  parameters: { layout: "centered" },
  args: {
    children: "Save changes", // TODO(design): the copy this component most often shows in the product
    onClick: fn(),
  },
} satisfies Meta<typeof Button>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {};

// One story per variant
export const Secondary: Story = {
  args: { variant: "secondary" },
};

export const Destructive: Story = {
  args: { variant: "destructive", children: "Delete project" },
};

// export const Hover: Story = {
//   parameters: { pseudo: { hover: true } },
// };

export const FocusVisible: Story = {
  play: async ({ canvas, userEvent }) => {
    await userEvent.tab();
    await expect(canvas.getByRole("button")).toHaveFocus();
  },
};

export const Disabled: Story = {
  args: { disabled: true },
};

export const Loading: Story = {
  args: { loading: true }, // TODO(design): delete if the component has no loading state
};

export const LongContent: Story = {
  args: { children: "Save all changes and notify every member of this project" },
};

export const Dark: Story = {
  decorators: [
    (Story) => (
      <div className="dark bg-background p-6">
        <Story />
      </div>
    ),
  ],
};

export const Compact: Story = {
  decorators: [
    (Story) => (
      <div data-density="compact">
        <Story />
      </div>
    ),
  ],
};
