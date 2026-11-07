export default function Page() {
  return (
    <main className="bg-blue-500 hover:text-white p-[13px] data-[state=open]:p-2">
      <p style={{ color: "#c62828" }}>Error</p>
      <p style={{ color: "rgb(0 0 0)" }}>Black</p>
      <a href="#faq">FAQ</a>
      <div className="text-gray-600">TODO(design)</div>
      <div className="bg-[#fafafa]" /> {/* design-check-ignore: fixed background required by a third-party embed */}
    </main>
  );
}
