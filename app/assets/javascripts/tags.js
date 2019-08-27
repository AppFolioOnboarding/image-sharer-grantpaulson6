$('#add-tag').click( e => {
  e.preventDefault();

  const new_tag_text = $('#tag-adder').val();
  if (!new_tag_text) return;
  const tag_container = $.parseHTML("<div class=\"alert alert-success alert-dismissible fade show\" role=\"alert\">\n" +
    `${new_tag_text}\n` +
    "  <button type=\"button\" class=\"close\" data-dismiss=\"alert\" aria-label=\"Close\">\n" +
    "    <span aria-hidden=\"true\">&times;</span>\n" +
    "  </button>\n" +
    "</div>");

  const tag = document.createElement('input');
  tag.setAttribute('type', 'hidden');
  tag.setAttribute('name', 'image[tag_list][]');
  tag.setAttribute('value', new_tag_text);
  $(tag_container).append(tag);
  $('#submit-image').before(tag_container);
  $('#tag-adder').val('');
})
