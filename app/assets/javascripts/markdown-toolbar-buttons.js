MarkdownToolbar.buttons = [
  {title: 'Bold',          type: 'wrapper',  left: '**', right: '**', id: 'bold'},
  {title: 'Italic',        type: 'wrapper',  left: '*',  right: '*',  id: 'italic'},
  {id: 'delimiter'},
  {title: 'Bulleted list', type: 'prefixer', left: '- ',              id: 'list_bullets'},
  {title: 'Numbered list', type: 'list_numbers', id: 'list_numbers'},  
  {title: 'Blockquote',    type: 'prefixer', left: '> ',              id: 'blockquote'},
  // Code:
  {title: 'Source Code',   type: 'block_wrapper',   left: "```\n", right: "\n```", id: 'code'},  
  {id: 'delimiter'},
  {title: 'Image',         type: 'image',        id: 'image'},
  {title: 'Link',          type: 'link',         id: 'link'},
];
