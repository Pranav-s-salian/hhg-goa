/**
 * CustomerExplanation: Displays a simple, jargon-free explanation suitable for customers
 * Shows what happened and what we're doing about it in plain language
 */
"use client";

interface Props {
  explanation?: string;
  verdict: "fraud" | "legitimate" | "uncertain";
  pattern: string;
}

export function CustomerExplanation({ explanation, verdict, pattern }: Props) {
  if (!explanation) return null;

  return (
    <div className="rounded-lg border border-blue-200 bg-blue-50 p-4 shadow-sm">
      <div className="flex items-start">
        <div className="flex-1">
          <h3 className="text-sm font-semibold text-gray-900 mb-2">
            Customer-Friendly Explanation
          </h3>
          <div className="text-sm text-gray-700 leading-relaxed whitespace-pre-wrap">
            {explanation}
          </div>
          {verdict === "fraud" && (
            <div className="mt-3 text-xs text-gray-600 bg-white rounded px-3 py-2 border border-gray-200">
              <strong>Next Steps:</strong> We'll review this activity and may contact you to verify these transactions.
            </div>
          )}
          {verdict === "uncertain" && (
            <div className="mt-3 text-xs text-gray-600 bg-white rounded px-3 py-2 border border-gray-200">
              <strong>Next Steps:</strong> We need more information to determine if this activity is genuine. You may receive a verification request.
            </div>
          )}
          {verdict === "legitimate" && (
            <div className="mt-3 text-xs text-gray-600 bg-white rounded px-3 py-2 border border-gray-200">
              <strong>Status:</strong> No further action needed. This activity appears normal.
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
